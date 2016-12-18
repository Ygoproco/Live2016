--炎神－不知火
--Shiranui Sovereignsaga
--Scripted by Eerie Code
function c59843383.initial_effect(c)
	c:SetSPSummonOnce(59843383)
	--synchro summon
	aux.AddSynchroProcedure(c,c59843383.synfilter,aux.NonTuner(c59843383.synfilter),1)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59843383,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c59843383.tdtg)
	e1:SetOperation(c59843383.tdop)
	c:RegisterEffect(e1)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c59843383.reptg)
	e4:SetValue(c59843383.repval)
	c:RegisterEffect(e4)
end

function c59843383.synfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end

function c59843383.tdfil(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToDeck()
end
function c59843383.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	local g=Duel.GetMatchingGroup(c59843383.tdfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetCount()>0 and dc>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c59843383.tdop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	local g=Duel.GetMatchingGroup(c59843383.tdfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
	if g:GetCount()==0 or dg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,dg:GetCount(),nil)
	local rc=Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	if rc>0 and Duel.SelectYesNo(tp,aux.Stringid(59843383,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg2=dg:Select(tp,rc,rc,nil)
		Duel.Destroy(sg2,REASON_EFFECT)
	end
end

function c59843383.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsRace(RACE_ZOMBIE) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c59843383.repfil2(c)
	return c:IsSetCard(0xd9) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c59843383.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c59843383.repfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c59843383.repfil2,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(59843383,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c59843383.repfil2,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function c59843383.repval(e,c)
	return c59843383.repfilter(c,e:GetHandlerPlayer())
end
