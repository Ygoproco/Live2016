--Number 5: Des Chimera Dragon
function c511000509.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.XyzFilterFunction(c,5),2,nil,nil,5)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c511000509.atkval)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000509,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCost(c511000509.spcost)
	e2:SetTarget(c511000509.sptg)
	e2:SetOperation(c511000509.spop)
	c:RegisterEffect(e2)
	--register effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511000509,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c511000509.cost)
	e3:SetCondition(c511000509.condition)
	e3:SetOperation(c511000509.operation)
	c:RegisterEffect(e3)
end
c511000509.xyz_number=5
function c511000509.atkval(e,c)
	return c:GetOverlayCount()*900
end
function c511000509.spfilter(c)
	return c:GetLevel()==5
end
function c511000509.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1200) end
	local lp=Duel.GetLP(tp)
	local ct=Duel.GetMatchingGroupCount(c511000509.spfilter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)
	local t={}
	local l=1
	while l<=ct and l*1200<lp do
		t[l]=l*1200
		l=l+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511000509,1))
	local announce=Duel.AnnounceNumber(e:GetHandler():GetControler(),table.unpack(t))
	Duel.PayLPCost(tp,announce)
	e:SetLabel(announce/1200)
end
function c511000509.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.IsExistingMatchingCard(c511000509.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c511000509.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,c511000509.spfilter,tp,LOCATION_GRAVE,0,ct,ct,nil)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(e:GetHandler(),g)
		e:GetHandler():CompleteProcedure()
	end
end
function c511000509.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511000509.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c511000509.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(c511000509.atcon)
	e1:SetOperation(c511000509.atop)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c511000509.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable()
end
function c511000509.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
