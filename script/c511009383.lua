--D/D Brownie
--Fixed By TheOnePharaoh
function c511009383.initial_effect(c)
	--pendulum summon 
	aux.EnablePendulumAttribute(c) 
	--SelfSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66762372,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c511009383.spcon)
	e1:SetTarget(c511009383.sptg)
	e1:SetOperation(c511009383.spop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c511009383.effcon)
	e2:SetOperation(c511009383.regop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17540705,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(c511009383.sccon)
	e3:SetCost(c511009383.sccost)
	e3:SetTarget(c511009383.sctg)
	e3:SetOperation(c511009383.scop)
	c:RegisterEffect(e3)
end

function c511009383.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA and c:GetPreviousControler()==tp
end
function c511009383.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511009383.cfilter,1,nil,tp)
end
function c511009383.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c511009383.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c511009383.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c511009383.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(511009383+1,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end

function c511009383.sccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(511009383+1)~=0
end
function c511009383.tfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf)
end
function c511009383.filter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7)
end
function c511009383.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.CheckReleaseGroup(tp,c511009383.tfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c511009383.tfilter,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c511009383.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c511009383.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511009383.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c511009383.filter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c511009383.scop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
