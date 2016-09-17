--Number Ci1000: Numerronius Numerronia
function c511000296.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,13,5)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000296,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(c511000296.spcon)
	e1:SetTarget(c511000296.sptg)
	e1:SetOperation(c511000296.spop)
	c:RegisterEffect(e1)
	--indes effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e3)
	--checker
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(0xFF)
	e4:SetCondition(c511000296.chkcon)
	e4:SetOperation(c511000296.chkop)
	c:RegisterEffect(e4)
	--win
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetOperation(c511000296.winop)
	c:RegisterEffect(e5)
	--negate attack
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(511000296,1))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BE_BATTLE_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c511000296.nacon)
	e6:SetCost(c511000296.nacost)
	e6:SetOperation(c511000296.naop)
	c:RegisterEffect(e6)
end
c511000296.xyz_number=1000
function c511000296.cfilter(c,tp,code)
	return c:IsCode(code) and c:GetPreviousControler()==tp and c:IsReason(REASON_DESTROY) and c:GetOverlayCount()==0
end
function c511000296.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511000296.cfilter,1,nil,tp,511000294)
end
function c511000296.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c511000296.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:SetMaterial(eg)
		Duel.Overlay(c,eg)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c511000296.chkcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c511000296.chkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,511000296)~=0 then return end
	Duel.RegisterFlagEffect(tp,511000296,RESET_PHASE+PHASE_END,0,1)
end
function c511000296.winfilter2(c)
	return c:GetEffectCount(EFFECT_CANNOT_ATTACK)==0 and c:GetEffectCount(EFFECT_CANNOT_ATTACK_ANNOUNCE)==0 and c:GetAttackedCount()==0 and c:IsFaceup()
end
function c511000296.winfilter3(c)
	return (c:GetEffectCount(EFFECT_CANNOT_ATTACK)~=0 or c:GetEffectCount(EFFECT_CANNOT_ATTACK_ANNOUNCE)~=0) and c:IsFaceup()
end
function c511000296.fdfilter(c)
	return c:IsAttackPos() and c:IsFacedown()
end
function c511000296.winop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>0 
		and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1 and Duel.GetFlagEffect(tp,511000296)==0 then
		
		local g=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
		Duel.ChangePosition(g,0,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
		local g2=Duel.GetMatchingGroup(c511000296.fdfilter,tp,0,LOCATION_MZONE,nil)
		Duel.ChangePosition(g2,POS_FACEUP_ATTACK)
		if not Duel.IsExistingMatchingCard(c511000296.winfilter2,Duel.GetTurnPlayer(),LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(c511000296.winfilter3,Duel.GetTurnPlayer(),LOCATION_MZONE,0,1,nil) then
			
			local tc=g:GetFirst()
			while tc do
				Duel.ChangePosition(g,tc:GetPreviousPosition())
				tc=g:GetNext()
			end
			tc=g2:GetFirst()
			while tc do
				Duel.ChangePosition(g2,tc:GetPreviousPosition())
				tc=g2:GetNext()
			end
		else
			local WIN_REASON_NUMBER_Ci1000=0x52
			Duel.Win(tp,WIN_REASON_NUMBER_Ci1000)
		end
	end
end
function c511000296.nacon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return bt:GetControler()==c:GetControler()
end
function c511000296.nacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511000296.naop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.Recover(e:GetHandler():GetControler(),Duel.GetAttacker():GetAttack(),REASON_EFFECT)
	end
end
