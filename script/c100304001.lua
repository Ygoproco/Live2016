--Ultimate Conductor Tyranno
function c100304001.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100304001.spcon)
	e1:SetOperation(c100304001.spop)
	c:RegisterEffect(e1)
	
	--destroy and change pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100304001,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c100304001.condition)
	e2:SetTarget(c100304001.destg)
	e2:SetOperation(c100304001.desop)
	c:RegisterEffect(e2)
	
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	
	--destroy DEF monster
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100304001,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetTarget(c100304001.targ)
	e4:SetOperation(c100304001.op)
	c:RegisterEffect(e4)
end
function c100304001.spfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsAbleToRemoveAsCost()
end
function c100304001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100304001.spfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c100304001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c100304001.spfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

function c100304001.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c100304001.filter2(c)
	return c:IsType(TYPE_MONSTER)
end
function c100304001.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c100304001.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100304001.filter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) 
		and Duel.IsExistingMatchingCard(c100304001.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE+LOCATION_HAND)
end
function c100304001.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c100304001.filter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local g2=Duel.GetMatchingGroup(c100304001.filter,tp,0,LOCATION_MZONE,nil)
		Duel.ChangePosition(g2,POS_FACEDOWN_DEFENSE)
	end
end

function c100304001.targ(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk ==0 then	return Duel.GetAttacker()==e:GetHandler()
		and d~=nil and d:IsDefensePos() and d:IsRelateToBattle() end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,d,1,0,0)
end
function c100304001.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(1-tp,1000,REASON_EFFECT)==1000 then
		local d=Duel.GetAttackTarget()
		if d~=nil and d:IsRelateToBattle() and d:IsDefensePos() then
			Duel.SendtoGrave(d,REASON_EFFECT)
		end
	end
end